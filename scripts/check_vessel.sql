SELECT b.nombre_buque, b.matricula, bt.id as tray_id, COUNT(btp.id) as puntos_count, MAX(btp.timestamp) as ultimo_punto
FROM buques b
LEFT JOIN buque_trayectorias bt ON b.id = bt.buque_id
LEFT JOIN buque_trayectoria_puntos btp ON bt.id = btp.trayectoria_id
WHERE b.nombre_buque ILIKE '%LU QING YUAN YU 277%'
GROUP BY b.nombre_buque, b.matricula, bt.id;
