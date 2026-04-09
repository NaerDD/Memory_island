package com.memoryisland.repository;

import com.memoryisland.entity.BottleMessage;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BottleMessageRepository extends JpaRepository<BottleMessage, Long> {
}
