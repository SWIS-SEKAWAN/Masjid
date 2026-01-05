import express from "express";
import bodyParser from "body-parser";
import cors from "cors";
import adminRoutes from "./routes/adminRoutes";
import lectureRoutes from "./routes/lectureRoutes";
import cashflowRoutes from "./routes/cashflowRoutes";

const app = express();
const PORT = process.env.PORT || 3000;

app.use(
  cors({
    origin: true, // Allow all origins
    credentials: true,
  })
);
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// ✅ ROOT ROUTE
app.get("/", (req, res) => {
  res.json({
    status: "OK",
    message: "Backend Sistem Informasi Masjid berjalan 🚀",
    endpoints: {
      admin: "/api/admin",
      lectures: "/api/lectures",
      cashflows: "/api/cashflows",
    },
  });
});

app.use("/api/admin", adminRoutes);
app.use("/api/lectures", lectureRoutes);
app.use("/api/cashflows", cashflowRoutes);

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
