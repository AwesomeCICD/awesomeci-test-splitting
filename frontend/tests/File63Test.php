<?php
use PHPUnit\Framework\TestCase;
use Demo\File63;

class File63Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File63::add(2, 3));
    }
}
