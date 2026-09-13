import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import postRouter from "./routes/post.route";
import categoryRouter from "./routes/category.route";

dotenv.config();

const app = express();

app.use(cors());
app.use(express.json());

app.get("/", (req, res) => {
    res.json({
        message: "Blog API is running"
    });
});

app.use("/api/posts", postRouter);
app.use("/api/categories", categoryRouter);

const PORT = 3000;

app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});