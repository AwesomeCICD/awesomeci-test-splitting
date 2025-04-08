<?php
use PHPUnit\Framework\TestCase;
use Demo\File38;

class File38Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File38::add(2, 3));
    }
}
