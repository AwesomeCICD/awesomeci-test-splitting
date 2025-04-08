<?php
use PHPUnit\Framework\TestCase;
use Demo\File98;

class File98Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File98::add(2, 3));
    }
}
