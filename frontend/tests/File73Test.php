<?php
use PHPUnit\Framework\TestCase;
use Demo\File73;

class File73Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File73::add(2, 3));
    }
}
