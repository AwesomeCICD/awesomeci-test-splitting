<?php
use PHPUnit\Framework\TestCase;
use Demo\File23;

class File23Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File23::add(2, 3));
    }
}
