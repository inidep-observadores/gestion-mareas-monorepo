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

    // Base course determined by general trajectory (North-East = 45°)
    // This is more realistic for vessels in the Argentine Sea
    const baseCourse = 45

    // Apply ±15% variation to the base course for realism
    const courseVariation = baseCourse * 0.15 * (Math.random() * 2 - 1) // ±15%
    const currentCourse = (baseCourse + courseVariation + 360) % 360

    // Displacement approx based on speed (knots to degrees approx)
    // 1 knot is approx 0.00016 degrees per second? No, let's keep it simple.
    // Let's say each point is 15 mins apart.
    const intervalMinutes = 15
    const distance = (speed * (intervalMinutes / 60)) / 60 // rough degree dist

    // Calculate displacement based on course
    // Course 0° = North, 90° = East, 180° = South, 270° = West
    currentLat += distance * Math.cos((currentCourse * Math.PI) / 180)
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
