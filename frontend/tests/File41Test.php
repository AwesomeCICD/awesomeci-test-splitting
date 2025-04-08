<?php
use PHPUnit\Framework\TestCase;
use Demo\File41;

class File41Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File41::add(2, 3));
    }
}
