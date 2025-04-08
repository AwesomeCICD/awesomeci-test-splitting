<?php
use PHPUnit\Framework\TestCase;
use Demo\File37;

class File37Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File37::add(2, 3));
    }
}
