<?php
use PHPUnit\Framework\TestCase;
use Demo\File1;

class File1Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File1::add(2, 3));
    }
}
