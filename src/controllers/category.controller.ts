import { Request, Response } from "express";
import { db } from "../config/database";

export const getCategories = async (req: Request, res: Response) => {
    try {
        const [categories] = await db.query(
            "SELECT id, name FROM categories ORDER BY id ASC"
        );

        return res.status(200).json({
            success: true,
            message: "Categories fetched successfully",
            data: categories
        });
    } catch (error: any) {
        console.error("Error:", error);

        return res.status(500).json({
            success: false,
            message: "Failed to fetch categories",
            error: error.message
        });
    }
};