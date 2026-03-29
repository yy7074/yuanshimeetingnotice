import { MaterialsService } from './materials.service';
import { Material } from './entities/material.entity';
export declare class MaterialsController {
    private materialsService;
    constructor(materialsService: MaterialsService);
    findByEvent(eventId: string, req: any): Promise<Material[]>;
    create(eventId: string, data: Partial<Material>): Promise<Material>;
    update(id: string, data: Partial<Material>): Promise<Material>;
    remove(id: string): Promise<Material>;
    download(id: string): Promise<Material>;
}
