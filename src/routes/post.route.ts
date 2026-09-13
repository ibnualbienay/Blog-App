import { Router } from "express";

import {
    getPosts,
    getPostById,
    createPost,
    updatePost,
    deletePost
} from "../controllers/post.controller";

const router = Router();

router.get("/", getPosts);
router.get("/:id", getPostById);
router.post("/", createPost);
router.put("/:id", updatePost);
router.delete("/:id", deletePost);

export default router;