import { ref } from 'vue';

const LOCAL_STORAGE_KEY = 'sigma_attachment_view_mode';
const saved = localStorage.getItem(LOCAL_STORAGE_KEY);
const viewMode = ref<'list' | 'inline'>((saved === 'inline' || saved === 'list') ? saved : 'list');

export const useAttachmentViewMode = () => {
    const toggleViewMode = () => {
        viewMode.value = viewMode.value === 'inline' ? 'list' : 'inline';
        localStorage.setItem(LOCAL_STORAGE_KEY, viewMode.value);
    };

    return {
        viewMode,
        toggleViewMode
    };
};
