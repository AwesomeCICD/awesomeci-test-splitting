<?php
use PHPUnit\Framework\TestCase;
use Demo\File87;

class File87Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File87::add(2, 3));
    }
}
