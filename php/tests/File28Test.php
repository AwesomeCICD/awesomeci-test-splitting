<?php
use PHPUnit\Framework\TestCase;
use Demo\File28;

class File28Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File28::add(2, 3));
    }
}
