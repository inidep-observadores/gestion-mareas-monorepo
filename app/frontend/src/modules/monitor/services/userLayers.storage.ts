export interface UserMapLayer {
  id: string
  name: string
  color: string
  isVisible: boolean
  showDescriptions: boolean
  importedAt: string
  geojson: object
}

const DB_NAME = 'sigma_map'
const DB_VERSION = 1
const STORE = 'user_layers'

const openDb = (): Promise<IDBDatabase> =>
  new Promise((resolve, reject) => {
    const req = indexedDB.open(DB_NAME, DB_VERSION)
    req.onupgradeneeded = () => {
      if (!req.result.objectStoreNames.contains(STORE)) {
        req.result.createObjectStore(STORE, { keyPath: 'id' })
      }
    }
    req.onsuccess = () => resolve(req.result)
    req.onerror = () => reject(req.error)
  })

const run = async <T>(mode: IDBTransactionMode, op: (store: IDBObjectStore) => IDBRequest<T>): Promise<T> => {
  const db = await openDb()
  try {
    return await new Promise<T>((resolve, reject) => {
      const tx = db.transaction(STORE, mode)
      const req = op(tx.objectStore(STORE))
      tx.oncomplete = () => resolve(req.result)
      tx.onerror = () => reject(tx.error)
      tx.onabort = () => reject(tx.error)
    })
  } finally {
    db.close()
  }
}

export const userLayersStorage = {
  async getAll(): Promise<UserMapLayer[]> {
    const all = await run<UserMapLayer[]>('readonly', s => s.getAll())
    return all.sort((a, b) => a.importedAt.localeCompare(b.importedAt))
  },
  async put(layer: UserMapLayer): Promise<void> {
    await run('readwrite', s => s.put(layer))
  },
  async remove(id: string): Promise<void> {
    await run('readwrite', s => s.delete(id))
  }
}
