package com.memoryisland.repository;

import com.memoryisland.entity.SharedCollection;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SharedCollectionRepository extends JpaRepository<SharedCollection, Long> {
}
