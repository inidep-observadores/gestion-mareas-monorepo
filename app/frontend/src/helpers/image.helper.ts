export const getFullImageUrl = (path: string | undefined): string => {
    if (!path) return '/images/user/default_avatar.png'; // Default image

    if (path.startsWith('http') || path.startsWith('blob:')) return path;

    // Get API Origin (e.g., http://localhost:3000)
    const apiUrl = import.meta.env.VITE_BACKEND_URL;

    // If apiUrl has /api at the end, remove it to get the host, OR just use URL object
    try {
        const base = typeof window !== 'undefined' ? window.location.origin : 'http://localhost';
        const url = new URL(apiUrl || '', base);
        const formattedPath = path.startsWith('/') ? path : `/${path}`;
        return `${url.origin}${formattedPath}`;
    } catch (error) {
        return path;
    }
}
