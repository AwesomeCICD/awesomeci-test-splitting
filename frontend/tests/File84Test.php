<?php
use PHPUnit\Framework\TestCase;
use Demo\File84;

class File84Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File84::add(2, 3));
    }
}
