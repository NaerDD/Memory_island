package com.memoryisland.entity;

import javax.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "memory_comments")
public class MemoryComment {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "memory_id")
    private MemoryRecord memory;

    private String authorName;

    @Column(length = 2000)
    private String content;

    private LocalDateTime createdAt;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public MemoryRecord getMemory() { return memory; }
    public void setMemory(MemoryRecord memory) { this.memory = memory; }
    public String getAuthorName() { return authorName; }
    public void setAuthorName(String authorName) { this.authorName = authorName; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
}
