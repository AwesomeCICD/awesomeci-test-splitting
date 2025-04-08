<?php
use PHPUnit\Framework\TestCase;
use Demo\File57;

class File57Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File57::add(2, 3));
    }
}
