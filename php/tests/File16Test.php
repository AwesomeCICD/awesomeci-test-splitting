<?php
use PHPUnit\Framework\TestCase;
use Demo\File16;

class File16Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File16::add(2, 3));
    }
}
