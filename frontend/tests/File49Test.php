<?php
use PHPUnit\Framework\TestCase;
use Demo\File49;

class File49Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File49::add(2, 3));
    }
}
