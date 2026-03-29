export declare enum SpeakerCategory {
    KEYNOTE = "keynote",
    VIP_GUEST = "vip_guest",
    RESEARCH = "research",
    WORKSHOP = "workshop"
}
export declare class Speaker {
    id: string;
    nameEn: string;
    nameZh: string;
    titleEn: string;
    titleZh: string;
    organizationEn: string;
    organizationZh: string;
    bioEn: string;
    bioZh: string;
    avatarUrl: string;
    category: SpeakerCategory;
    createdAt: Date;
    updatedAt: Date;
}
