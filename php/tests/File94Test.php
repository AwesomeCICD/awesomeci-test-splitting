<?php
use PHPUnit\Framework\TestCase;
use Demo\File94;

class File94Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File94::add(2, 3));
    }
}
