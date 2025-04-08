<?php
use PHPUnit\Framework\TestCase;
use Demo\File12;

class File12Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File12::add(2, 3));
    }
}
