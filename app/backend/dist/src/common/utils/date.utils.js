"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.DateUtils = void 0;
const constants_1 = require("../constants");
class DateUtils {
    static formatDate(date) {
        if (!date)
            return '-';
        const d = new Date(date);
        if (isNaN(d.getTime()))
            return '-';
        const day = d.getDate().toString().padStart(2, '0');
        const month = (d.getMonth() + 1).toString().padStart(2, '0');
        const year = d.getFullYear();
        return constants_1.APP_CONFIG.DATE_FORMAT
            .replace('DD', day)
            .replace('MM', month)
            .replace('YYYY', year.toString());
    }
    static calculateInclusiveDays(start, end) {
        if (!start)
            return 0;
        const startDate = new Date(start);
        const endDate = end ? new Date(end) : new Date();
        startDate.setHours(0, 0, 0, 0);
        endDate.setHours(0, 0, 0, 0);
        if (isNaN(startDate.getTime()) || isNaN(endDate.getTime()))
            return 0;
        if (endDate < startDate)
            return 0;
        const diffTime = Math.abs(endDate.getTime() - startDate.getTime());
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        return diffDays + 1;
    }
    static calculateDaysInYear(start, end, year) {
        if (!start)
            return 0;
        const startDate = new Date(start);
        startDate.setHours(0, 0, 0, 0);
        const endDate = end ? new Date(end) : startDate;
        endDate.setHours(0, 0, 0, 0);
        const yearStart = new Date(year, 0, 1, 0, 0, 0, 0);
        const yearEnd = new Date(year, 11, 31, 0, 0, 0, 0);
        const effectiveStart = startDate < yearStart ? yearStart : startDate;
        const effectiveEnd = endDate > yearEnd ? yearEnd : endDate;
        if (effectiveStart > effectiveEnd)
            return 0;
        const diffTime = Math.abs(effectiveEnd.getTime() - effectiveStart.getTime());
        const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
        return diffDays + 1;
    }
    static calculateUniqueDays(intervals, year) {
        if (!intervals.length)
            return 0;
        const normalized = intervals
            .map(i => {
            const s = new Date(i.start);
            const e = i.end ? new Date(i.end) : new Date();
            s.setHours(0, 0, 0, 0);
            e.setHours(0, 0, 0, 0);
            return { start: s, end: e };
        })
            .filter(i => !isNaN(i.start.getTime()) && !isNaN(i.end.getTime()) && i.end >= i.start)
            .sort((a, b) => a.start.getTime() - b.start.getTime());
        if (!normalized.length)
            return 0;
        const merged = [];
        let current = normalized[0];
        for (let i = 1; i < normalized.length; i++) {
            const next = normalized[i];
            if (next.start.getTime() <= current.end.getTime()) {
                if (next.end.getTime() > current.end.getTime()) {
                    current.end = next.end;
                }
            }
            else {
                merged.push(current);
                current = next;
            }
        }
        merged.push(current);
        return merged.reduce((acc, interval) => {
            if (year) {
                return acc + this.calculateDaysInYear(interval.start, interval.end, year);
            }
            return acc + this.calculateInclusiveDays(interval.start, interval.end);
        }, 0);
    }
    static truncateTime(date) {
        if (!date)
            return null;
        const d = new Date(date);
        if (isNaN(d.getTime()))
            return null;
        d.setHours(0, 0, 0, 0);
        return d;
    }
}
exports.DateUtils = DateUtils;
//# sourceMappingURL=date.utils.js.map