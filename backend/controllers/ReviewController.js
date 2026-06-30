const Review = require("../models/ReviewModel");

exports.getReviews = async(req,res)=>{
    try{
        const {bookId} = req.params;
        const reviews = await Review.getBookReviews(bookId);
        const summary = await Review.getReviewSummary(bookId);
        res.json({
            averageRating: summary.average_rating || 0,
            totalReview: summary.total_review || 0,
            reviews
        });
    }catch(err){
        console.log(err);
        res.status(500).json({
            message:"Internal Server Error"
        });
    }
};

exports.addReview = async(req,res)=>{
    try{
        const userId = req.user.user_id || req.user.id || req.user.id_user;
        const {bookId,rating,comment} = req.body;
        if(!rating){
            return res.status(400).json({
                message:"Rating wajib diisi"
            });
        }
        const existing = await Review.getUserReview(userId,bookId);
        if(existing){
            await Review.updateReview(
                existing.review_id,
                rating,
                comment
            );
            return res.json({
                message:"Review berhasil diperbarui"
            });
        }
        await Review.createReview(
            userId,
            bookId,
            rating,
            comment
        );
        res.json({
            message:"Review berhasil ditambahkan"
        });
    }catch(err){
        console.log(err);
        res.status(500).json({
            message:"Internal Server Error"
        });
    }
};