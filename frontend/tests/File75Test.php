<?php
use PHPUnit\Framework\TestCase;
use Demo\File75;

class File75Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File75::add(2, 3));
    }
}
