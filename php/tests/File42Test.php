<?php
use PHPUnit\Framework\TestCase;
use Demo\File42;

class File42Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File42::add(2, 3));
    }
}
