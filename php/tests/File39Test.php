<?php
use PHPUnit\Framework\TestCase;
use Demo\File39;

class File39Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File39::add(2, 3));
    }
}
