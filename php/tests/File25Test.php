<?php
use PHPUnit\Framework\TestCase;
use Demo\File25;

class File25Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File25::add(2, 3));
    }
}
