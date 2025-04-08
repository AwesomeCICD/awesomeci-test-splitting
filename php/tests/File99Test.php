<?php
use PHPUnit\Framework\TestCase;
use Demo\File99;

class File99Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File99::add(2, 3));
    }
}
