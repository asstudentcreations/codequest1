
package com.codequest.model;

public class Course {

    private int courseId;
    private String title;
    private String description;
    private String category;
    private String difficulty;
    private String duration;
    private int totalLessons;
    private int completedLessons;

    public Course(int courseId, String title, String description,
                  String category, String difficulty, String duration,
                  int totalLessons, int completedLessons) {

        this.courseId = courseId;
        this.title = title;
        this.description = description;
        this.category = category;
        this.difficulty = difficulty;
        this.duration = duration;
        this.totalLessons = totalLessons;
        this.completedLessons = completedLessons;
    }

    public int getCourseId() {
        return courseId;
    }

    public String getTitle() {
        return title;
    }

    public String getDescription() {
        return description;
    }

    public String getCategory() {
        return category;
    }

    public String getDifficulty() {
        return difficulty;
    }

    public String getDuration() {
        return duration;
    }

    public int getTotalLessons() {
        return totalLessons;
    }

    public int getCompletedLessons() {
        return completedLessons;
    }

    public int getProgressPercentage() {
        if (totalLessons == 0) {
            return 0;
        }

        return (completedLessons * 100) / totalLessons;
    }
}
