<?php
use PHPUnit\Framework\TestCase;
use Demo\File65;

class File65Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File65::add(2, 3));
    }
}
