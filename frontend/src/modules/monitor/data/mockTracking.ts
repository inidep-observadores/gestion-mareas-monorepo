export interface TrackingPoint {
  timestamp: string
  lat: number
  lon: number
  speed: number
  course: number
  status: 'sailing' | 'fishing' | 'maneuvering'
}

export function generateMockTrack(startTime: Date, pointsCount: number = 200): TrackingPoint[] {
  const points: TrackingPoint[] = []
  let currentLat = -42.5
  let currentLon = -60.2
  let currentTime = new Date(startTime)

  for (let i = 0; i < pointsCount; i++) {
    // Simulate some movement logic
    // We'll move mostly South-East
    const isFishing = i > 50 && i < 150 && i % 20 < 15
    const speed = isFishing ? 2.5 + Math.random() * 2 : 8.5 + Math.random() * 3

    // Change course slightly
    const courseChange = (Math.random() - 0.5) * 10
    const currentCourse = (135 + courseChange) % 360

    // Displacement approx based on speed (knots to degrees approx)
    // 1 knot is approx 0.00016 degrees per second? No, let's keep it simple.
    // Let's say each point is 15 mins apart.
    const intervalMinutes = 15
    const distance = (speed * (intervalMinutes / 60)) / 60 // rough degree dist

    currentLat -= distance * Math.cos((currentCourse * Math.PI) / 180)
    currentLon += distance * Math.sin((currentCourse * Math.PI) / 180)

    points.push({
      timestamp: currentTime.toISOString(),
      lat: Number(currentLat.toFixed(5)),
      lon: Number(currentLon.toFixed(5)),
      speed: Number(speed.toFixed(1)),
      course: Math.round(currentCourse),
      status: speed < 4.5 ? 'fishing' : speed < 6.5 ? 'maneuvering' : 'sailing',
    })

    currentTime = new Date(currentTime.getTime() + intervalMinutes * 60000)
  }

  return points
}
