package com.memoryisland.repository;

import com.memoryisland.entity.MemoryComment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MemoryCommentRepository extends JpaRepository<MemoryComment, Long> {
}
