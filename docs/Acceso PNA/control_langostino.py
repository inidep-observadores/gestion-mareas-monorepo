from zeep import Client
import psycopg2
import psycopg2.extras
import datetime
import time
# import biblio
# import requests
# from requests.auth import HTTPDigestAuth
# import json

# from zeep.wsse.username import UsernameToken

# fecha_inicial = '2019-01-10'
# url1 = url + 'fch_salida=' + fecha_inicial
# conn = psycopg2.connect("host=10.0.64.12 dbname=pesca")
conn = psycopg2.connect("dbname=pesca host=localhost port=5432")

conn.set_session(autocommit=True)
local = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)

horas = 3  # horas entre actualizaciones del control
repeticion = 3600 * horas  # intervalo de espera en segundos en time.sleep()
prefec_si = 1

anio = 2025
antes = '2024'
siglo = '20'
conteo = 0
todos = 0
origen = 'P'
min = 1
k = 0

# if prefec_si == 1:
# cliente = Client('http://webservicesscp.prefecturanaval.gov.ar:8897/WsPescaExternos.asmx?wsdl')
cliente= Client('https://sscpwsexternos.prefecturanaval.gob.ar/WsPescaExternos.asmx?wsdl')

# bajo datos de monitoreo desde prefectura
j = 0
while 1:
    local.execute("select max(fecha_local) as maximo from monitoreo.prefectura")
    # local.execute("select '2025-12-31 00:00:00'::timestamp as maximo")
    # local.execute("select max(fecha_local) as maximo from monitoreo.prefectura_2019")  # para datos de enero 2020
    fechamax = local.fetchall()
    intervalo = datetime.datetime.now() - fechamax[0]['maximo']
    rango = int(intervalo.total_seconds() / (3600 * 6) + 1)
    for d in range(0, rango + 1):
        # if d < rango:
        principio = fechamax[0]['maximo'] + datetime.timedelta(hours=1)
        # principio = fechamax[0]['maximo']
        desde = principio + datetime.timedelta(hours=(d * 6))
        hasta = principio + datetime.timedelta(hours=(d + 1) * 6)
        # else:
        #     desde = fechamax[0]['maximo'] - datetime.timedelta(hours=1)
        #     hasta = datetime.datetime.now() + datetime.timedelta(hours=4)

        # desde = datetime.datetime(2018, 9, 8, 0, 0, 0) - datetime.timedelta(hours=24)
        desde = desde.replace(second=0, microsecond=0)
        # hasta = datetime.datetime(2018, 9, 8, 0, 0, 0)

        hasta = hasta.replace(second=0, microsecond=0)
        # if prefec_si == 1:
        # cliente = Client('http://sscp.prefecturanaval.gov.ar:8897/WsPescaExternos.asmx?wsdl')
        # a = cliente.service.GetPosicionesHistoricas(user='pescanacion', password='pesnac49715', desde=desde,
        #                                             hasta=hasta)
        a = cliente.service.GetPosicionesHistoricas(user='inidep', password='0634BFA3-D80E-4565-89D3-20B96191EAAD',
                                                    desde=desde,
                                                    hasta=hasta)
        if a.Reportes is None:
            continue
        if len(a.Reportes['Reporte']) == 0:
            continue
        for i in range(0, len(a.Reportes['Reporte'])):
            try:
                if a.Reportes['Reporte'][i]['matricula'][-7:]=='0001587':
                    a.Reportes['Reporte'][i]['matricula'][-7:]='0001567'
                local.execute(
                    "select idpos from monitoreo.prefectura where matricula=%s and fecha=%s and longitud is not distinct from %s and latitud is not distinct from %s and mmsi is not distinct from %s and emp is not distinct from %s and dnid is not distinct from %s and mem is not distinct from %s and velocidad is not distinct from %s and rumbo is not distinct from %s",
                    (a.Reportes['Reporte'][i]['matricula'][-7:], a.Reportes['Reporte'][i]['fecha'],
                     a.Reportes['Reporte'][i]['longitud'], a.Reportes['Reporte'][i]['latitud'],
                     a.Reportes['Reporte'][i]['mmsi'], a.Reportes['Reporte'][i]['emp'],
                     a.Reportes['Reporte'][i]['dnid'],a.Reportes['Reporte'][i]['mem'],
                     a.Reportes['Reporte'][i]['velocidad'],
                     a.Reportes['Reporte'][i]['rumbo']))
            except Exception as err:
                continue
            esta = local.fetchall()
            pos_id = esta
            print('{:%Y-%m-%d %H:%M:%S}'.format(desde), 'registro', i, 'nuevos', j, 'existe:', esta,
                  a.Reportes['Reporte'][i]['nombre'])
            if len(esta) == 0:
                # continue
                fch_local = datetime.datetime.strptime(a.Reportes['Reporte'][i]['fecha'],
                                                       '%Y-%m-%d %H:%M:%S') - datetime.timedelta(hours=3)
                local.execute(
                    "insert into monitoreo.prefectura (id_empresa,nombre_empresa,matricula,mmsi,nro_omi,nombre,latitud,longitud,fecha, fecha_local, rumbo,velocidad,emp,dnid,mem,eslora,geom) values(%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,st_geomfromtext('POINT(%s %s)',4326)) returning idpos",
                    (a.Reportes['Reporte'][i]['id_empresa'], a.Reportes['Reporte'][i]['nombre_empresa'],
                     a.Reportes['Reporte'][i]['matricula'][-7:], a.Reportes['Reporte'][i]['mmsi'],
                     a.Reportes['Reporte'][i]['nro_omi'],
                     a.Reportes['Reporte'][i]['nombre'], a.Reportes['Reporte'][i]['latitud'],
                     a.Reportes['Reporte'][i]['longitud'],
                     a.Reportes['Reporte'][i]['fecha'], fch_local,
                     a.Reportes['Reporte'][i]['rumbo'],
                     a.Reportes['Reporte'][i]['velocidad'],
                     a.Reportes['Reporte'][i]['emp'], a.Reportes['Reporte'][i]['dnid'], a.Reportes['Reporte'][i]['mem'],
                     a.Reportes['Reporte'][i]['eslora'], a.Reportes['Reporte'][i]['longitud'],
                     a.Reportes['Reporte'][i]['latitud']))
                pos_id = local.fetchall()
                # calculo fecha_local porque la que viene es GMT
                local.execute(
                    "update monitoreo.prefectura set fecha_local=fecha-'03:00:00'::interval, idbuques=a.idbuques from datos.buques a where lpad(prefectura.matricula,7,'0')=a.mat_sat and idpos=%s",
                    (pos_id[0]['idpos'],))
                j=j+1
            '''
            local.execute(
                "SELECT idpos,idbuques,date_trunc('minute', fecha), rumbo, velocidad, latitud, longitud FROM monitoreo.prefectura WHERE idpos=%s ",
                (pos_id[0]['idpos'],))
            p = local.fetchone()
            if p[1] is None:
                continue
            todos = todos + 1
            # print(todos, 'total ', conteo, 'error', j, p[0])
            fechagmt = p[2]
            # if fechagmt.year not in (int(anio), int(antes)):
            #     j = j + 1
            #     continue
            # if fechagmt.year == int(antes) and fechagmt.month < 1:
            #     j = j + 1
            #     continue

            locall = fechagmt - datetime.timedelta(hours=3)
            anniio = locall.year
            # cur.execute("select idvms from datos.vms where idbuques=%s and fecha=%s and baliza=%s",
            local.execute("select idvms from monitoreo.vms where fecha=%s and idbuques=%s",
                          (locall, p[1]))
            # (barco[0]['idbuques'], fechagmt, baliza))
            monit = local.fetchall()
            if len(monit) == 0:
                l = "insert into monitoreo.vms(idbuques,fecha,vel, rumbo,geom,idpos) values(%s,'%s',%s,%s,st_geomfromtext('POINT(%s %s)',4326),'%s') returning idvms" % (
                    p[1], locall, p[4], p[3], p[6], p[5], p[0])
                #            print l
                local.execute(l)
                monit = local.fetchall()
                #            registr.write('%s;\r\n'% (cur.query))
                #            cur.execute("insert into datos.vms (idbuques,fecha,fcha_local,vel, rumbo,geom,baliza,validado) values(%s,'%s','%s',%s,%s,st_geomfromtext('POINT(%s %s)',4326),'%s',true)",(barco[0]['idbuques'],fechagmt,local,vel,rumbo,longi,lati,baliza))
                conteo = conteo + 1
                j = j + 1
                biblio.puertos(local, monit[0]['idvms'], anio)
                # biblio.mareas(conn, local, monit[0]['idvms'], locall)
            else:
                local.execute("update monitoreo.vms set idpos=%s where idvms=%s ",
                              (p[0], monit[0]['idvms']))
            #            registr.write('%s;\r\n'% (cur.query))
            local.execute("update monitoreo.prefectura set ingresado=true where idpos=%s", (p[0],))

            fecha = locall
            punto = monit[0]['idvms']
            barco = p[1]
            origen = 'P'
            '''
            # registro la marea del punto en VMS
            # id = biblio.mareas(local, punto, fecha)
            # if id > 0:
            #     biblio.calcula_distancia_marea(local, id)
            #     biblio.ubica_partes_marea(local, id)
            '''
            inicio = fecha - datetime.timedelta(days=180)
            fin = fecha + datetime.timedelta(days=180)
            local.execute(
                "SELECT idvms,(fecha-%s) AS despues, fecha FROM monitoreo.vms WHERE idbuques=%s AND (fecha-%s)>'00:00'::INTERVAL AND fecha BETWEEN %s AND %s ORDER BY 2 ASC LIMIT 1",
                (fecha, barco, fecha, inicio, fin))
            pto = local.fetchall()
            if len(pto) > 0:
                local.execute("UPDATE monitoreo.vms SET posterior=%s WHERE idvms=%s",
                              (pto[0]['idvms'], punto))
                local.execute("UPDATE monitoreo.vms SET anterior=%s WHERE idvms=%s",
                              (punto, pto[0]['idvms']))
            local.execute(
                "SELECT idvms,(%s-fecha) AS antes, fecha FROM monitoreo.vms WHERE idbuques=%s AND (%s-fecha)>'00:00'::INTERVAL AND fecha BETWEEN %s AND %s  ORDER BY 2 ASC LIMIT 1",
                (fecha, barco, fecha, inicio, fin))
            pto1 = local.fetchall()
            if len(pto1) > 0:
                local.execute("UPDATE monitoreo.vms SET anterior=%s WHERE idvms=%s",
                              (pto1[0]['idvms'], punto))
                local.execute("UPDATE monitoreo.vms SET posterior=%s WHERE idvms=%s",
                              (punto, pto1[0]['idvms']))

            # Busco el registro en monit

            local.execute("SELECT idmonit FROM monitoreo.monit WHERE idbuques=%s AND fecha=%s AND idvms=%s",
                          (barco, fecha, punto))
            mon = local.fetchall()
            if len(mon) > 0:
                # local.execute("UPDATE monitoreo.monit SET validado=TRUE WHERE idmonit=%s", (anio, mon[0]['idmonit']))
                # conn.commit()
                existe = True
                # continue
            else:
                existe = False
            if existe == False:
                local.execute(
                    "SELECT idmonit,(fecha-%s) AS despues, fecha FROM monitoreo.monit WHERE idbuques=%s AND (fecha-%s)>'00:00'::INTERVAL AND fecha BETWEEN %s AND %s  ORDER BY 2 ASC LIMIT 1",
                    (fecha, barco, fecha, inicio, fin))
                pto = local.fetchall()
                local.execute(
                    "SELECT idmonit,(%s-fecha) AS antes, fecha FROM monitoreo.monit WHERE idbuques=%s AND (%s-fecha)>'00:00'::INTERVAL AND fecha BETWEEN %s AND %s  ORDER BY 2 ASC LIMIT 1",
                    (fecha, barco, fecha, inicio, fin))
                pto1 = local.fetchall()
                if len(pto) == 0 and len(pto1) == 0 and existe is False:
                    local.execute(
                        "INSERT INTO monitoreo.monit (idvms,idbuques, fecha,rumbo,vel,idprts,pesca,arte,flota,geom,criterio)  (SELECT idvms,idbuques, fecha,rumbo,vel,idprts,pesca,arte,flota,geom,criterio FROM monitoreo.vms WHERE idvms=%s)",
                        (punto,))
                    # cur.execute("update datos.monit%s set ")
                    # j = j + 1
                if len(pto) > 0 and len(pto1) > 0:
                    if pto1[0]['antes'] > datetime.timedelta(minutes=55) and pto[0]['despues'] > datetime.timedelta(
                            minutes=55):
                        if existe is False:
                            local.execute(
                                "INSERT INTO monitoreo.monit (idvms,idbuques, fecha,rumbo,vel,idprts,pesca,arte,flota,geom,criterio)  (SELECT idvms,idbuques, fecha,rumbo,vel,idprts,pesca,arte,flota,geom,criterio FROM monitoreo.vms WHERE idvms=%s)",
                                (punto,))
                        local.execute(
                            "UPDATE monitoreo.monit SET posterior=%s, anterior=%s WHERE idvms=%s and fecha=%s",
                            (pto[0]['idmonit'], pto1[0]['idmonit'], punto, fecha))
                        local.execute("UPDATE monitoreo.monit SET posterior=%s WHERE idmonit=%s and fecha=%s",
                                      (punto, pto1[0]['idmonit'], pto1[0]['fecha']))
                        local.execute("UPDATE monitoreo.monit SET anterior=%s WHERE idmonit=%s and fecha=%s",
                                      (punto, pto[0]['idmonit'], pto[0]['fecha']))
                        # j = j + 1
                if len(pto) == 0 and len(pto1) > 0:
                    if pto1[0]['antes'] > datetime.timedelta(minutes=55):
                        if existe is False:
                            local.execute(
                                "INSERT INTO monitoreo.monit (idvms,idbuques, fecha,rumbo,vel,idprts,pesca,arte,flota,geom,criterio)  (SELECT idvms,idbuques, fecha,rumbo,vel,idprts,pesca,arte,flota,geom,criterio FROM monitoreo.vms WHERE idvms=%s)",
                                (punto,))
                            j = j + 1
                        local.execute("UPDATE monitoreo.monit SET anterior=%s WHERE idvms=%s and fecha=%s",
                                      (pto1[0]['idmonit'], punto, fecha))
                        local \
                            .execute("UPDATE monitoreo.monit SET posterior=%s WHERE idmonit=%s and fecha=%s",
                                     (punto, pto1[0]['idmonit'], pto1[0]['fecha']))
                if len(pto1) == 0 and len(pto) > 0:
                    if pto[0]['despues'] > datetime.timedelta(minutes=55):
                        if existe is False:
                            local.execute(
                                "INSERT INTO monitoreo.monit (idvms,idbuques, fecha,rumbo,vel,idprts,pesca,arte,flota,geom,criterio)  (SELECT idvms,idbuques, fecha,rumbo,vel,idprts,pesca,arte,flota,geom,criterio FROM monitoreo.vms WHERE idvms=%s)",
                                (punto,))
                            # j = j + 1
                        local.execute("UPDATE monitoreo.monit SET posterior=%s WHERE idvms=%s and fecha=%s",
                                      (pto[0]['idmonit'], punto, fecha))
                        local.execute("UPDATE monitoreo.monit SET anterior=%s WHERE idmonit=%s and fecha=%s",
                                      (punto, pto[0]['idmonit'], pto[0]['fecha']))

            # monitoreo cada 15 minutos
            #
            # local.execute("SELECT idmonit15 FROM monitoreo.monit15 WHERE idbuques=%s AND fecha=%s AND idvms=%s",
            #               (barco, fecha, punto))
            # mon = local.fetchall()
            # if len(mon) > 0:
            #     # local.execute("UPDATE monitoreo.monit15 SET validado=TRUE WHERE idmonit15=%s", (mon[0]['idmonit15'],))
            #     # conn.commit()
            #     existe = True
            #     # continue
            # else:
            #     existe = False
            # if existe == False:
            #     local.execute(
            #         "SELECT idmonit15,(fecha-%s) AS despues, fecha FROM monitoreo.monit15 WHERE idbuques=%s AND (fecha-%s)>'00:00'::INTERVAL AND fecha BETWEEN %s AND %s  ORDER BY 2 ASC LIMIT 1",
            #         (fecha, barco, fecha, inicio, fin))
            #     pto = local.fetchall()
            #     local.execute(
            #         "SELECT idmonit15,(%s-fecha) AS antes, fecha FROM monitoreo.monit15 WHERE idbuques=%s AND (%s-fecha)>'00:00'::INTERVAL AND fecha BETWEEN %s AND %s  ORDER BY 2 ASC LIMIT 1",
            #         (fecha, barco, fecha, inicio, fin))
            #     pto1 = local.fetchall()
            #     if len(pto) == 0 and len(pto1) == 0 and existe is False:
            #         local.execute(
            #             "INSERT INTO monitoreo.monit15 (idvms,idbuques, fecha,rumbo,vel,idprts,pesca,arte,flota,geom,criterio)  (SELECT idvms,idbuques, fecha,rumbo,vel,idprts,pesca,arte,flota,geom,criterio FROM monitoreo.vms WHERE idvms=%s)",
            #             (punto,))
            #         k = k + 1
            #     if len(pto) > 0 and len(pto1) > 0:
            #         if pto1[0]['antes'] > datetime.timedelta(minutes=14) and pto[0]['despues'] > datetime.timedelta(
            #                 minutes=14):
            #             if existe is False:
            #                 local.execute(
            #                     "INSERT INTO monitoreo.monit15 (idvms,idbuques, fecha,rumbo,vel,idprts,pesca,arte,flota,geom,criterio)  (SELECT idvms,idbuques, fecha,rumbo,vel,idprts,pesca,arte,flota,geom,criterio FROM monitoreo.vms WHERE idvms=%s)",
            #                     (punto,))
            #                 k = k + 1
            #             local.execute(
            #                 "UPDATE monitoreo.monit15 SET anterior=%s, posterior=%s WHERE idvms=%s and fecha=%s",
            #                 (pto1[0]['idmonit15'], pto[0]['idmonit15'], punto, fecha))
            #             local.execute("UPDATE monitoreo.monit15 SET posterior=%s WHERE idmonit15=%s and fecha=%s",
            #                         (punto, pto1[0]['idmonit15'], pto1[0]['fecha']))
            #             local.execute("UPDATE monitoreo.monit15 SET anterior=%s WHERE idmonit15=%s and fecha=%s",
            #                         (punto, pto[0]['idmonit15'], pto[0]['fecha']))
            #
            #     if len(pto) == 0 and len(pto1) > 0:
            #         if pto1[0]['antes'] > datetime.timedelta(minutes=14):
            #             if existe is False:
            #                 local.execute(
            #                     "INSERT INTO monitoreo.monit15 (idvms,idbuques, fecha,rumbo,vel,idprts,pesca,arte,flota,geom,criterio)  (SELECT idvms,idbuques, fecha,rumbo,vel,idprts,pesca,arte,flota,geom,criterio FROM monitoreo.vms WHERE idvms=%s)",
            #                     (punto,))
            #                 k = k + 1
            #             local.execute(
            #                 "UPDATE monitoreo.monit15 SET anterior=%s WHERE idvms=%s and fecha=%s",
            #                 (pto1[0]['idmonit15'], punto, fecha))
            #             local.execute("UPDATE monitoreo.monit15 SET posterior=%s WHERE idmonit15=%s and fecha=%s",
            #                         (punto, pto1[0]['idmonit15'], pto1[0]['fecha']))
            #
            #     if len(pto1) == 0 and len(pto) > 0:
            #         if pto[0]['despues'] > datetime.timedelta(minutes=14):
            #             if existe is False:
            #                 local.execute(
            #                     "INSERT INTO monitoreo.monit15 (idvms,idbuques, fecha,rumbo,vel,idprts,pesca,arte,flota,geom,criterio)  (SELECT idvms,idbuques, fecha,rumbo,vel,idprts,pesca,arte,flota,geom,criterio FROM monitoreo.vms WHERE idvms=%s)",
            #                     (punto,))
            #                 k = k + 1
            #             local.execute(
            #                 "UPDATE monitoreo.monit15 SET posterior=%s WHERE idvms=%s and fecha=%s",
            #                 (pto[0]['idmonit15'], punto, fecha))
            #             local.execute("UPDATE monitoreo.monit15 SET anterior=%s WHERE idmonit15=%s and fecha=%s",
            #                         (punto, pto[0]['idmonit15'], pto[0]['fecha']))
            #             # local.execute("UPDATE datos.monit15 SET anterior=%s, t_antes=%s WHERE idmonit15=%s",
            #             #               (punto, pto[0]['despues'], pto1[0]['idmonit15']))

            # buscar parte y criterio para puerto y vel crucero - modificar biblio para que haga update en vms, monit y monit15
            #biblio.parte(local, punto, anio)
            # continue

           # if biblio.puertos(local, punto, anniio) is True:
            #    continue

            #if biblio.chile(local, p[0], anniio) is True:
             #   continue

            #if biblio.uruguay(local, punto, anniio) is True:
             #   continue

            #if biblio.tierra(local, punto, anniio) is True:
             #   continue

            #if biblio.vel_crucero(local, punto, anniio) is True:
             #   continue '''
    print('Final', datetime.datetime.now())
    # if rango<=1:
    time.sleep(repeticion)
