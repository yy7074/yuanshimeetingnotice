export declare class UploadController {
    uploadFile(file: Express.Multer.File): {
        url: string;
        originalName: string;
        size: number;
        mimetype: string;
    };
}
