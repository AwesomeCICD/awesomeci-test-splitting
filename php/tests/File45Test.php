<?php
use PHPUnit\Framework\TestCase;
use Demo\File45;

class File45Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File45::add(2, 3));
    }
}
