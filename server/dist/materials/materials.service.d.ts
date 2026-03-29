import { Repository } from 'typeorm';
import { Material } from './entities/material.entity';
export declare class MaterialsService {
    private materialRepo;
    constructor(materialRepo: Repository<Material>);
    findByEvent(eventId: string, userRole?: string): Promise<Material[]>;
    findOne(id: string): Promise<Material>;
    create(data: Partial<Material>): Promise<Material>;
    update(id: string, data: Partial<Material>): Promise<Material>;
    remove(id: string): Promise<Material>;
    incrementDownload(id: string): Promise<Material>;
}
