<?php
use PHPUnit\Framework\TestCase;
use Demo\File85;

class File85Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File85::add(2, 3));
    }
}
