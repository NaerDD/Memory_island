package com.memoryisland.repository;

import com.memoryisland.entity.MemoryRecord;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface MemoryRecordRepository extends JpaRepository<MemoryRecord, Long> {
    @EntityGraph(attributePaths = "building")
    List<MemoryRecord> findAllByOrderByHappenedAtDescIdDesc();

    @Override
    @EntityGraph(attributePaths = "building")
    Optional<MemoryRecord> findById(Long id);
}
