
package com.codequest.model;

public class CourseLesson {

    private int lessonId;
    private String title;
    private String content;
    private String codeExample;
    private String outputExample;
    private int lessonOrder;
    private boolean completed;

    public CourseLesson(int lessonId, String title, String content,
                        String codeExample, String outputExample,
                        int lessonOrder, boolean completed) {
        this.lessonId = lessonId;
        this.title = title;
        this.content = content;
        this.codeExample = codeExample;
        this.outputExample = outputExample;
        this.lessonOrder = lessonOrder;
        this.completed = completed;
    }

    public int getLessonId() {
        return lessonId;
    }

    public String getTitle() {
        return title;
    }

    public String getContent() {
        return content;
    }

    public String getCodeExample() {
        return codeExample;
    }

    public String getOutputExample() {
        return outputExample;
    }

    public int getLessonOrder() {
        return lessonOrder;
    }

    public boolean isCompleted() {
        return completed;
    }
}
