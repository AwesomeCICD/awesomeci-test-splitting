<?php
use PHPUnit\Framework\TestCase;
use Demo\File90;

class File90Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File90::add(2, 3));
    }
}
