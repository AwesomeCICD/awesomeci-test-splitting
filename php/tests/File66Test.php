<?php
use PHPUnit\Framework\TestCase;
use Demo\File66;

class File66Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File66::add(2, 3));
    }
}
