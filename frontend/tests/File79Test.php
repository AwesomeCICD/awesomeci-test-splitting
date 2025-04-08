<?php
use PHPUnit\Framework\TestCase;
use Demo\File79;

class File79Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File79::add(2, 3));
    }
}
