export const getFullImageUrl = (path: string | undefined): string => {
    if (!path) return '/images/user/default_avatar.png'; // Default image

    if (path.startsWith('http') || path.startsWith('blob:')) return path;

    // Get API Origin (e.g., http://localhost:3000)
    const apiUrl = import.meta.env.BACKEND_URL || 'http://localhost:3000/api';

    // If apiUrl has /api at the end, remove it to get the host, OR just use URL object
    try {
        const url = new URL(apiUrl);
        return `${url.origin}${path}`;
    } catch (error) {
        return path;
    }
}
