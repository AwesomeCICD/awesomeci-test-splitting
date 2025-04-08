<?php
use PHPUnit\Framework\TestCase;
use Demo\File32;

class File32Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File32::add(2, 3));
    }
}
