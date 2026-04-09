package com.memoryisland.web.dto;

public class TopicDto {
    private String question;
    private String guide;

    public TopicDto() {
    }

    public TopicDto(String question, String guide) {
        this.question = question;
        this.guide = guide;
    }

    public String getQuestion() { return question; }
    public void setQuestion(String question) { this.question = question; }
    public String getGuide() { return guide; }
    public void setGuide(String guide) { this.guide = guide; }
}
