const express = require("express");
const router = express.Router();

const reviewController = require("../controllers/ReviewController");
const authMiddleware = require("../middleware/authMiddleware");

router.get("/:bookId", reviewController.getReviews);

router.post(
    "/",
    authMiddleware,
    reviewController.addReview
);

module.exports = router;