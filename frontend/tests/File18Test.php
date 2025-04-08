<?php
use PHPUnit\Framework\TestCase;
use Demo\File18;

class File18Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File18::add(2, 3));
    }
}
