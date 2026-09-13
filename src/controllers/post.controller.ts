import { Request, Response } from "express";
import { db } from "../config/database";

export const getPosts = async (req: Request, res: Response) => {
    try {
        const [rows] = await db.query(`
            SELECT
                posts.id,
                posts.title,
                posts.content,
                posts.category_id,
                categories.name AS category,
                posts.created_at,
                posts.updated_at
            FROM posts
            JOIN categories
                ON posts.category_id = categories.id
            ORDER BY posts.created_at DESC
        `);

        return res.status(200).json({
            success: true,
            message: "Fetch posts successful",
            data: rows
        });

    } catch (error: any) {
        console.error("Error:", error);

        return res.status(500).json({
            success: false,
            message: "Failed to fetch posts",
            error: error.message
        });
    }
};


export const getPostById = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;

        if (!/^\d+$/.test(String(id))) {
            return res.status(400).json({
                success: false,
                message: "Invalid post ID"
            });
        }

        const [rows]: any = await db.query(`
            SELECT
                posts.id,
                posts.title,
                posts.content,
                posts.category_id,
                categories.name AS category,
                posts.created_at,
                posts.updated_at
            FROM posts
            JOIN categories
                ON posts.category_id = categories.id
            WHERE posts.id = ?
        `, [id]);

        if (rows.length === 0) {
            return res.status(404).json({
                success: false,
                message: "Post not found"
            });
        }

        return res.status(200).json({
            success: true,
            message: "Fetch post successful",
            data: rows[0]
        });

    } catch (error: any) {
        console.error("Error:", error);

        return res.status(500).json({
            success: false,
            message: "Failed to fetch post",
            error: error.message
        });
    }
};


export const createPost = async (req: Request, res: Response) => {
    try {
        const { title, content, category_id } = req.body;

        if (typeof title !== "string" || title.trim() === "") {
            return res.status(400).json({
                success: false,
                message: "Title is required and must be a string"
            });
        }

        if (typeof content !== "string" || content.trim() === "") {
            return res.status(400).json({
                success: false,
                message: "Content is required and must be a string"
            });
        }

        if (
            typeof category_id !== "number" ||
            !Number.isInteger(category_id) ||
            category_id <= 0
        ) {
            return res.status(400).json({
                success: false,
                message: "category_id must be a positive integer"
            });
        }

        const [categories]: any = await db.query(
            "SELECT id FROM categories WHERE id = ?",
            [category_id]
        );

        if (categories.length === 0) {
            return res.status(400).json({
                success: false,
                message: "Category not found"
            });
        }

        const [result]: any = await db.query(
            `
            INSERT INTO posts (title, content, category_id)
            VALUES (?, ?, ?)
            `,
            [
                title.trim(),
                content.trim(),
                category_id
            ]
        );

        return res.status(201).json({
            success: true,
            message: "Post created successfully",
            data: {
                id: result.insertId,
                title: title.trim(),
                content: content.trim(),
                category_id
            }
        });

    } catch (error: any) {
        console.error("Error:", error);

        return res.status(500).json({
            success: false,
            message: "Failed to create post",
            error: error.message
        });
    }
};


export const updatePost = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;
        const { title, content, category_id } = req.body;

        if (!/^\d+$/.test(String(id))) {
            return res.status(400).json({
                success: false,
                message: "Invalid post ID"
            });
        }

        if (typeof title !== "string" || title.trim() === "") {
            return res.status(400).json({
                success: false,
                message: "Title is required and must be a string"
            });
        }

        if (typeof content !== "string" || content.trim() === "") {
            return res.status(400).json({
                success: false,
                message: "Content is required and must be a string"
            });
        }

        if (
            typeof category_id !== "number" ||
            !Number.isInteger(category_id) ||
            category_id <= 0
        ) {
            return res.status(400).json({
                success: false,
                message: "category_id must be a positive integer"
            });
        }

        const [posts]: any = await db.query(
            "SELECT id FROM posts WHERE id = ?",
            [id]
        );

        if (posts.length === 0) {
            return res.status(404).json({
                success: false,
                message: "Post not found"
            });
        }

        const [categories]: any = await db.query(
            "SELECT id FROM categories WHERE id = ?",
            [category_id]
        );

        if (categories.length === 0) {
            return res.status(400).json({
                success: false,
                message: "Category not found"
            });
        }

        await db.query(
            `
            UPDATE posts
            SET
                title = ?,
                content = ?,
                category_id = ?
            WHERE id = ?
            `,
            [
                title.trim(),
                content.trim(),
                category_id,
                id
            ]
        );

        return res.status(200).json({
            success: true,
            message: "Post updated successfully",
            data: {
                id: Number(id),
                title: title.trim(),
                content: content.trim(),
                category_id
            }
        });

    } catch (error: any) {
        console.error("Error:", error);

        return res.status(500).json({
            success: false,
            message: "Failed to update post",
            error: error.message
        });
    }
};


export const deletePost = async (req: Request, res: Response) => {
    try {
        const { id } = req.params;

        if (!/^\d+$/.test(String(id))) {
            return res.status(400).json({
                success: false,
                message: "Invalid post ID"
            });
        }

        const [posts]: any = await db.query(
            "SELECT id FROM posts WHERE id = ?",
            [id]
        );

        if (posts.length === 0) {
            return res.status(404).json({
                success: false,
                message: "Post not found"
            });
        }

        await db.query(
            "DELETE FROM posts WHERE id = ?",
            [id]
        );

        return res.status(200).json({
            success: true,
            message: "Post deleted successfully"
        });

    } catch (error: any) {
        console.error("Error:", error);

        return res.status(500).json({
            success: false,
            message: "Failed to delete post",
            error: error.message
        });
    }
};